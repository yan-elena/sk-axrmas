

+!checkQuality(Id)[source(Ag)]
    <-  .print("received assembly request check quality of ", Id);
        checkQuality;
        .print("quality checked: ", Id);
        .send(Ag, signal, checkedQuality(Id));
        .


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
