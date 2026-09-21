// number of orders (Received, Assigned)
ordersQueue(0, 0).

!setup_sai.
!start.


// ------------ Organization Management -----------------------
+!start : formationStatus(ok)
   <-   makeArtifact(anb,"adaptation.artifact.AdaptiveNormativeBoardSai",[],AId);
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

        +maxIAg(A, 0);

        .print("started.");
    .

+!start
   <-   .wait(1000);
        !start.



//connect norms to institution
+!setup_sai: focusing(ArtSai,inst_test_art,_,_,inst_test,_) & focusing(NplArt,anb,_,_,_,_) <-
   getSaiEngine(SE)[artifact_id(ArtSai)];
   setInstitution(SE)[artifact_id(NplArt)];
   .print("connected: ", ArtSai, NplArt);
  .

+!setup_sai<-
    .wait(focusing(ArtSai,inst_test_art,_,_,inst_test,_) & focusing(NplArt,anb,_,_,_,_));
    !setup_sai.



// Adaptation (Coded In the plans approach)

// when the orders in the queue are greater than 10, triggers the adaptation...
@detect_plan
+ordersQueue(R, A) : bottleneckThreshold(T) & R  - A = T
     <- .print("DETECTED TOO MANY ORDERS IN THE QUEUE!!");
        addFact(bottleneck);
        !detected(bottleneck);
        .print("---- BOTTLENECK!!! ----")
        .

@design_plan
+!detected(bottleneck)
    <-  getNorm(nSai2, Cond, Cons);
        Cond2 = order(Id, Ag, optionals, D);
        !designed(n2, Cond2, Cons);
        .print("DESIGNED NORM: ", n2, " IF ", Cond, " THEN ", Cons);
        .

@execute_plan
+!designed(n2, Cond, Cons)
    <-  modifyNorm(n2, Cond, Cons);
        getNorm(n2, Cond2, Cons);
        .print("---- NORM n2 EXECUTED ADAPTATION ---- to: ", Cond2, " ", Cons2);
        .

// Assign order to sca agents


+order(Id, Pref, D)
    <-  ?ordersQueue(R, A);
        -+ordersQueue(R+1, A);
        !selectAgent(order(Id, Pref, D));
        .


+!selectAgent(order(Id, Pref, D))
    <-  .print("selecting agent for order ", Id);

        !findMaxIAg;

        if (maxIAg(M, Im)) {
            .print("agent with MAX reputation: ", M);
            !assignOrder(Id, M, Pref, D);
        } else {
            .print("no free agent now, wait...");
            .wait(1000);
        }
        .

+!assignOrder(Id, Ag, Pref, D) : scaStatus(Ag2, busy, Id, N, Im)
    <-  .print("agent ", Ag2, " is busy with order ", Id);
        .

+!assignOrder(Id, Ag, Pref, D) : scaStatus(Ag, free, I, N, Im)
    <-  .print("assign order ", Id, " to agent ", Ag);
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, startOrder(Id));
        addFact(order(Id, Ag, Pref, D));
        ?ordersQueue(R, A);
        -+ordersQueue(R, A+1);
        .print("order ", Id, " assigned to agent ", Ag);
        .

+!assignOrder(Id, Ag, Pref, D) : scaStatus(Ag, busy, I, N, Im)
    <-  .wait(1000);
        !selectAgent(order(Id, Pref, D));
        .

+!findMaxIAg
    <-  -maxIAg(_, _);
        for (scaStatus(Ag, free, I, N, Im)) {
            if (maxIAg(MAg, MIm) & Im>= MIm) {
                    -maxIAg(MAg, MIm);
                    +maxIAg(Ag, Im);
                    .print("agent maxIm: ", maxIAg(Ag, Im));
            } else {
                +maxIAg(Ag, Im);
                .print("agent maxIm: ", maxIAg(Ag, Im));
            }
        }
        .

// order finished

+assembledBaseSk(Id)[source(Ag)]
    <-  .print("received ", assembledBaseSk(Id));
        addFact(assembledBaseSk(Id));
        .

+assembledOptionals(Id)[source(Ag)]
    <-  .print("received ", assembledOptionals(Id));
        addFact(assembledOptionals(Id));
        .

// ------------ Regulation Management -----------------------


+!enforceExecute(Sanctionee, increaseImage(X))
   <-   ?scaStatus(Sanctionee, S, Id, N, Im);
        -scaStatus(Sanctionee, S, Id, N, Im);
        +scaStatus(Sanctionee, S, Id, N,Im+X);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ",Im+X);
        .

+!enforceExecute(Sanctionee, decreaseImage(X))
   <-   ?scaStatus(Sanctionee, S, Id, N, Im);
        -scaStatus(Sanctionee, S, Id, N, Im);
        +scaStatus(Sanctionee, S, Id, N,Im-X);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ",Im-X);
        .

+obligation(Ag,Norm,What,Deadline) : .my_name(Ag)
   <-   .print("I am obliged to ",What);
        !What
        .

// send the obligation to the corresponding sca agent

+obligation(Ag,Norm,What,Deadline)
   <-   .print(Ag, " is obliged to ", What);
        .send(Ag, achieve, What, Deadline);
        ?scaStatus(Ag, S, I, N, Im);
        -scaStatus(Ag, S, I, N, Im);
        +scaStatus(Ag, busy, Id, N+1, Im);
        .

+oblFulfilled(obligation(Ag,Norm,What,Deadline))
    <-  .print("FULFILLED obligation: ", obligation(Ag,Norm,assembledBaseSk(Id),Deadline));
        if ((order(Id, Ag, base, D) & assembledBaseSk(Id)) | (order(Id, Ag, optionals, D) & assembledBaseSk(Id) & assembledOptionals(Id))) {
            ?play(Cca, customer, skgroup);
            .send(Cca, signal, completeOrder(Id));
        }
        .

+oblUnfulfilled(obligation(Ag,Norm,assembledBaseSk(Id),Deadline))
    <-  .print("UNFULFILLED obligation: ", obligation(Ag,Norm,assembledBaseSk(Id),Deadline));
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, delayOrder(Id));
        .

// enfoce capability

+sanction(Norm,Status,Sanctionee,Content)
   <-  .print("sanction ", sanction(Norm,Status,Sanctionee,Content));
       !enforceExecute(Sanctionee, Content);
        ?scaStatus(Sanctionee, S, Id, N, Im);
        -scaStatus(Sanctionee, S, Id, N, Im);
        +scaStatus(Sanctionee, free, Id, N+1, Im);
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
