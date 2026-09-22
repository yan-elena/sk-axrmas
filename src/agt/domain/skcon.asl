// number of orders (Received, Assigned)
ordersQueue(0, 0).

!setup_sai.
!start.


// ------------ Organization Management -----------------------
+!start : formationStatus(ok)
   <-   makeArtifact(anb,"adaptation.artifact.AdaptiveRegulationBoard",[],AId);
        focus(AId);
        debug(inspector_gui(on));
        .print("load norms...");
        load("src/reg/skregulative.npl");


        for (play(Ag, Role, Group)) {
            addFact(play(Ag, Role, Group));
            .print("add fact ", play(Ag, Role, Group));


            if(Role == skHandler) {
                +scaStatus(Ag, 0);
                addAgent(Ag);
                A=Ag;
            }
        }

        addSkFact(ordersQueue(0, 0));

        +maxIAg(A, 0);

        .print("started.");
    .

+!start
   <-   .wait(1000);
        !start.



//connect norms to institution
+!setup_sai: focusing(ArtSai,sk_inst_art,_,_,sk_inst,_) & focusing(NplArt,anb,_,_,_,_) <-
   getSaiEngine(SE)[artifact_id(ArtSai)];
   setInstitution(SE)[artifact_id(NplArt)];
   .print("connected: ", ArtSai, NplArt);
  .

+!setup_sai<-
    .wait(focusing(ArtSai,sk_inst_art,_,_,sk_inst,_) & focusing(NplArt,anb,_,_,_,_));
    !setup_sai.



// Adaptation plans

// when the orders in the queue are greater than 10, triggers the adaptation...
@detect_plan
+!realized(detect, [bottleneck, NId]) : sk(ordersQueue(R,A)) & bottleneckThreshold(T) & R - A > T
    <-  .print("DETECTED TOO MANY ORDERS IN THE QUEUE!!");
        addSkFact(detected(bottleneck));
        .print("BOTTLENECK!!!");
        .

+!realized(detect, [bottleneck, NId])
    <-  .print("Detect: no need for regulation adaptation");
        .wait(2000);
        !realized(detect, [bottleneck, NId]);
        .

@design_plan
+!realized(design, [NId, N2, Op])
    <-  getNorm(NId, Cond, Cons);
        Cond2 = order([Id, Ag, optionals, D]);
        N2 = [Cond, Cons];
        Op = modifyNorm;
        addSkFact(designed(N2, Op));
        .print("DESIGNED NORM: ", n2, " Cond: ", Cond, " Cons ", Cons, " Op: ", Op);
        .

@execute_plan
+!realized(execute, [NId, [Cond, Cons], modifyNorm])
    <-  modifyNorm(NId, Cond, Cons);
        addSkFact(executed(NId, [[Cond, Cons], modifyNorm]));
        getNorm(NId, Cond2, Cons2);
        .print("---- NORM ", NId, " EXECUTED ADAPTATION ---- to: ", Cond2, " ", Cons2);
        .



// Assign order to sca agents


+order(Id, Pref, D)
    <-  addOrder(Id, Pref, D);
        .

+order(Id, Ag, Pref, D)
    <-
        .print("PERCEIVED: ", order(Id, Ag, Pref, D));
        addFact(order(Id, Ag, Pref, D)).

+orderQueue(N)
    <-  .wait(1000);
        checkQueueAndAssign;
        .

// order finished

+assembledBaseSk(Id)[source(Ag)]
    <-  .print("received ", assembledBaseSk(Id));

        addFact(assembledBaseSk(Id));
        completeBaseSkateboard(Id);
        .

+assembledOptionals(Id)[source(Ag)]
    <-  .print("received ", assembledOptionals(Id));
        addFact(assembledOptionals(Id));

        completeOptionalsSkateboard(Id);
        .

// ------------ Regulation Management -----------------------


+!enforceExecute(Sanctionee, increaseImage(X))
   <-   ?scaStatus(Sanctionee, Im);
        +scaStatus(Sanctionee, Im+X);
        -scaStatus(Sanctionee, Im);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ",Im+X);
        .

+!enforceExecute(Sanctionee, decreaseImage(X))
   <-   ?scaStatus(Sanctionee, Im);
        +scaStatus(Sanctionee, Im-X);
        -scaStatus(Sanctionee, Im);
        .print("execute enforce capability on ", Sanctionee, " new reputation: ",Im-X);
        .

// process regulation adaptation

+obligation(Ag,Norm,What,Deadline) : .my_name(Ag)
   <-   .print("I am obliged to ", What);
        !!What;
        .

// send the obligation to the corresponding sca agent

+obligation(Ag,Norm,What,Deadline) : .my_name(Me) & Ag \== Me
   <-   .print("Obligation activated: ", obligation(Ag,Norm,What,Deadline));
        .send(Ag, achieve, What, Deadline);
        .

+oblFulfilled(obligation(Ag,Norm,What,Deadline)): .my_name(Me) & Ag \== Me
    <-  .print("FULFILLED obligation: ", obligation(Ag,Norm,assembledBaseSk(Id),Deadline));
        .

+oblUnfulfilled(obligation(Ag,Norm,assembledBaseSk(Id),Deadline)): .my_name(Me) & Ag \== Me
    <-  .print("UNFULFILLED obligation: ", obligation(Ag,Norm,assembledBaseSk(Id),Deadline));
        .

// enfoce capability

+sanction(Norm,Status,Sanctionee,Content)
   <-  .print("sanction ", sanction(Norm,Status,Sanctionee,Content));
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
