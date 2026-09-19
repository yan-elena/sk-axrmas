

+!assembly(Part, Id)[source(Ag)]
    <-  .print("received assembly request for part: ", Part, " of skateboard id: ", Id);
        assembly;
        .print("assembly finished for part: ", Part, " of skateboard id: ", Id);
        .send(Ag, signal, assembled(Part, Id));
        .


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
