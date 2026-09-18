!start.


// ------------ Organization Management -----------------------
+!start : formationStatus(ok)
   <-   makeArtifact(nb1,"ora4mas.nopl.NormativeBoard",[],AId);
        focus(AId);
        debug(inspector_gui(on));
        .print("load norms...");
        load("src/reg/skregulative.npl");

        for (play(Ag, Role, Group)) {
            addFact(play(Ag, Role, Group));
            .print("add fact ", play(Ag, Role, Group));

            // fact that indicates the status of the sca agents (agName, status, currentOrderId, completedNumber, reputation)

            if(Role == skHandler) {
                +scaStatus(Ag, free, -1, 0, 0);
                A=Ag;
            }
        }

        +maxRAg(A, 0);

        .print("started.");
    .

+!start
   <-   .wait(1000);
        !start.


+!testStatus
   <-   for (scaStatus(Ag, Status, Id, Completed, Reputation)) {
            .print(scaStatus(Ag, Status, Id, Completed, Reputation));
        }
        .


+scaStatus(Ag, Status, Id, Completed, Reputation)
    <-  .print("TEST:::: ", scaStatus(Ag, Status, Id, Completed, Reputation));
        .

// Assign order to sca agents


+order(Id, D)
    <-  !testStatus;
        !selectAgent(order(Id, D));
        .

+!selectAgent(order(Id, D)) : maxRAg(MaxAg, MaxR)
    <-  .print("selecting agent for order ", Id);

        for (scaStatus(Ag, free, I, N, R)) {
            if ( R >= MaxR ) {
                -+maxRAg(Ag, R);
                .print("agent max R: ", maxRAg(Ag, R));
            }
        }

        ?maxRAg(MaxRAg2, MaxR2);
        .print("agent with MAX reputation: ", maxRAg(MaxRAg2, MaxR2));

        if (MaxRAg) {
            !assignOrder(Id, MaxRAg2, D);
        } else {
            .print("no free agent now, wait...");
            .wait(1000);
            !selectAgent(order(Id, D));
        }
        .

+!assignOrder(Id, Ag, D) : scaStatus(Ag, free, I, N, R) & maxRAg(Ag, R)
    <-  .print("assign order ", Id, " to agent ", Ag);
        -scaStatus(Ag, free, I, N, R);
        +scaStatus(Ag, busy, Id, N+1, R);
        !testStatus;
        addFact(order(Id, Ag, D));
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, startOrder(Id));
        .print("order ", Id, " assigned to agent ", Ag);
        .

// order finished

+assembledSk(Id)[source(Ag)] : scaStatus(Ag, _, Id, N, _)
    <-  .print("add fact ", assembledSk(Id));
        addFact(assembledSk(Id));
        .



// ------------ Regulation Management -----------------------


+!enforceExecute(Sanctionee, increaseReputation(X))
   <-   !testStatus;
        ?scaStatus(Sanctionee, S, Id, N, R);
        -+scaStatus(Sanctionee, S, Id, N, R+X);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ", R+X);
        .

+!enforceExecute(Sanctionee, decreaseReputation(X))
   <-   !testStatus;
        ?scaStatus(Sanctionee, S, Id, N, R);
        -+scaStatus(Sanctionee, S, Id, N, R-X);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ", R-X);
        .

+obligation(Ag,Norm,What,Deadline) : .my_name(Ag)
   <-   .print("I am obliged to ",What);
        !What
        .

// send the obligation to the corresponding sca agent

+obligation(Ag,Norm,What,Deadline)
   <-   .print(Ag, " is obliged to ", What);
        .send(Ag, achieve, What, Deadline);
        .

+oblFulfilled(obligation(Ag,Norm,assembledSk(Id),Deadline))
    <-  .print("FULFILLED obligation: ", obligation(Ag,Norm,assembledSk(Id),Deadline));
        ?scaStatus(Ag, S, Id, N, R);
        -scaStatus(Ag, S, Id, N, R);
        +scaStatus(Ag, free, Id, N+1, R);
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, completeOrder(Id));
        .


// enfoce capability

+sanction(Norm,Status,Sanctionee,Content)
   <-  .print("sanction ", sanction(Norm,Status,Subject,Content));
       !enforceExecute(Sanctionee, Content);
       .


// Logs for an update of the normative state

+oblUnfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Norm,Status,Subject,Content)
   <- .print("sanction ", sanction(Norm,Status,Subject,Content)).



+nticks(T) : focusing(_,_,"ora4mas.nopl.NormativeBoard",_,_,_)
    <-  addFact(nticks(T));
        .

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
