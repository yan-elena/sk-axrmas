

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
            }
        }

        .print("started.");
    .

+!start
   <-   .wait(1000);
        !start.

+scaStatus(Ag, Status, Id, Completed, Reputation)
    <-  .print(scaStatus(Ag, Status, Id, Completed, Reputation));
        .

// Assign order to sca agents

+order(Id, D) : scaStatus(Ag, free, _, N, R)
    <-
        addFact(order(Id, Ag, D));
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, startOrder(Id));
        -+scaStatus(Ag, busy, Id, N+1, R);
        .print("order ", Id, " assigned to agent ", Ag);
        .

+!order(Id, D)
   <-   .print("order ", Id, " is waiting for an available agent!");
        .wait(1000);
        !order(Id, D).

// order finished

+assembledSk(Id)[source(Ag)] : scaStatus(Ag, _, Id, N, _)
    <-  .print("add fact", assembledSk(Id));
        addFact(assembledSk(Id));
        .



// ------------ Regulation Management -----------------------


+obligation(Ag,Norm,What,Deadline) : .my_name(Ag)
   <-   .print("I am obliged to ",What);
        !What
        .

// send the obligation to the corresponding sca agent

+obligation(Ag,n1,assembledSk(Id),Deadline)
   <-   .print(Ag, " is obliged to ", What);
        .send(Ag, achieve, What, Deadline);
        .


+fulfilled(obligation(Ag,n1,assembledSk(Id),Deadline))
    <-  -+scaStatus(Ag, free, Id, N+1, _);
        ?play(Cca, customer, skgroup);
        .send(Cca, signal, completeOrder(Id));
        .


// Logs for an update of the normative state

+oblUnfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Norm,Status,Subject,Content)
   <- .print("sanction ", sanction(Norm,Status,Subject,Content)).




{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
