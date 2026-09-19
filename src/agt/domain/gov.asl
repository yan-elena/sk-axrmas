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

+!selectAgent(order(Id, D))
    <-  .print("selecting agent for order ", Id);

        !findMaxRAg;

        if (maxRAg(M, R)) {
            .print("agent with MAX reputation: ", M);
            !assignOrder(Id, M, D);
        } else {
            .print("no free agent now, wait...");
            .wait(1000);
            !selectAgent(order(Id, D));
        }
        .

+!assignOrder(Id, Ag, D) : scaStatus(Ag2, busy, Id, N, R)
    <-  .print("agent ", Ag2, " is busy with order ", Id);
        .

+!assignOrder(Id, Ag, D) : scaStatus(Ag, free, I, N, R)
    <-  .print("assign order ", Id, " to agent ", Ag);
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, startOrder(Id));
        addFact(order(Id, Ag, D));
        .print("order ", Id, " assigned to agent ", Ag);
        .

+!assignOrder(Id, Ag, D) : scaStatus(Ag, busy, I, N, R)
    <-  .wait(1000);
        !selectAgent(order(Id, D));
        .

+!findMaxRAg
    <-  -maxRAg(_, _);
        for (scaStatus(Ag, free, I, N, R)) {
            if (maxRAg(MAg, MR) & R >= MR ) {
                    -maxRAg(MAg, MR);
                    +maxRAg(Ag, R);
                    .print("agent max R: ", maxRAg(Ag, R));
            } else {
                +maxRAg(Ag, R);
                .print("agent max R: ", maxRAg(Ag, R));
            }
        }
        .

// order finished

+assembledSk(Id)[source(Ag)]
    <-  .print("received ", assembledSk(Id));
        addFact(assembledSk(Id));
        .



// ------------ Regulation Management -----------------------


+!enforceExecute(Sanctionee, increaseReputation(X))
   <-   !testStatus;
        ?scaStatus(Sanctionee, S, Id, N, R);
        -scaStatus(Sanctionee, S, Id, N, R);
        +scaStatus(Sanctionee, S, Id, N, R+X);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ", R+X);
        .

+!enforceExecute(Sanctionee, decreaseReputation(X))
   <-   !testStatus;
        ?scaStatus(Sanctionee, S, Id, N, R);
        -scaStatus(Sanctionee, S, Id, N, R);
        +scaStatus(Sanctionee, S, Id, N, R-X);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ", R-X);
        .

+obligation(Ag,Norm,What,Deadline) : .my_name(Ag)
   <-   .print("I am obliged to ",What);
        !What
        .

// send the obligation to the corresponding sca agent

+obligation(Ag,Norm,assembledSk(Id),Deadline)
   <-   .print(Ag, " is obliged to ", assembledSk(Id));
        .send(Ag, achieve, assembledSk(Id), Deadline);
        ?scaStatus(Ag, S, I, N, R);
        -scaStatus(Ag, S, I, N, R);
        +scaStatus(Ag, busy, Id, N+1, R);
        !testStatus;
        .

+oblFulfilled(obligation(Ag,Norm,assembledSk(Id),Deadline))
    <-  .print("FULFILLED obligation: ", obligation(Ag,Norm,assembledSk(Id),Deadline));
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, completeOrder(Id));
        .

+oblUnfulfilled(obligation(Ag,Norm,assembledSk(Id),Deadline))
    <-  .print("UNFULFILLED obligation: ", obligation(Ag,Norm,assembledSk(Id),Deadline));
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, delayOrder(Id));
        .

// enfoce capability

+sanction(Norm,Status,Sanctionee,Content)
   <-  .print("sanction ", sanction(Norm,Status,Sanctionee,Content));
       !enforceExecute(Sanctionee, Content);
        ?scaStatus(Sanctionee, S, Id, N, R);
        -scaStatus(Sanctionee, S, Id, N, R);
        +scaStatus(Sanctionee, free, Id, N+1, R);
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
