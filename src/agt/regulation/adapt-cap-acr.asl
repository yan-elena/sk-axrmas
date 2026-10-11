!init.

+!init
    <-  .random(R);
        B=R*10;
        // add a random bottleneck threshold for each of the agent-centric agent
        +bottleneckThreshold(B);
        .my_name(Ag);
        addAgent(Ag);
        .

// Adaptation plans

// when the orders in the queue are greater than 10, triggers the adaptation...
@detect[adapt]
+!realized(detect, [bottleneck, NId]) : orderQueue(N) & bottleneckThreshold(T) & N > T
    <-  .print("DETECTED TOO MANY ORDERS IN THE QUEUE!!");
        addRmFact(detected(bottleneck));
        .print("BOTTLENECK!!!");
        .

+!realized(detect, [bottleneck, NId])
    <-  .print("Detect: no need for regulation adaptation");
        .wait(2000);
        !realized(detect, [bottleneck, NId]);
        .

//design(Cond, order(Id, Ag, true, D)).

@design[adapt]
+!realized(design, [NId, N2, Op])
    <-  getNorm(NId, Cond, Cons);
        Cond2 = order(Id, Ag, true, D);
        Cons2 =  Cons; //test: obligation(Ag, Cond2, assemblyWheels(4), D);
        N2 = [Cond2, Cons2];
        Op = modifyNorm;
        addSkFact(designed(N2, Op));
        .print("DESIGNED NORM: ", n2, " Cond: ", Cond2, " Cons ", Cons2, " Op: ", Op);
        .

@execute[adapt]
+!realized(execute, [NId, [Cond, Cons], modifyNorm])
    <-  modifyNorm(NId, Cond, Cons);
        addSkFact(executed(NId, [[Cond, Cons], modifyNorm]));
        getNorm(NId, Cond2, Cons2);
        .print("---- NORM ", NId, " EXECUTED ADAPTATION ---- to: ", Cond2, " ", Cons2);
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