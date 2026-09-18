


+!assembledSk(Id)[source(gov)]
    <-
        .print("start assembly skateboard id: ", Id);
        installTrunk;
        .print("trunk installed on ", Id);
        assemblyWheel;
        .print("wheel assembled on ", Id);
        torqueTrunk;
        .print("trunk torqued on ", Id);

        .print("completed assembly skateboard id: ", Id);
        ?play(Ag, skHandler, skgroup);
        .send(Ag, signal, assembledSk(Id));
        .




{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
