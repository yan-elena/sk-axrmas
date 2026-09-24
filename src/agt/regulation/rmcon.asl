
+rm(O)
    <- .print("PERCEIVED FACT FROM SK: ", O) .


// Regulation Management


+active(obligation(Me, M, O,D)) : .my_name(Me)
    <-  .print("I am obliged to achieve: ", O);
        .

+active(obligation(Ag, M, O,D))
    <-  .print(Ag, " is obliged to achieve: ", O);
        .send(Ag, achieve, O);
        .print("sent obligation to ", Ag);
        .

+Instance[source(npli)]
    <-  .print("NPL FACT: ", Instance) .

+Constitutive[source(np)]
    <-  .print("SAI FACT: ", Constitutive) .

+active(O)
    <-  .print("active obligation: ", O);
        .

+fulfilled(O)
    <-  .print("fulfilled obligation: ", O).

+unfulfilled(O)
    <-  .print("unfulfilled obligation: ", O).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
