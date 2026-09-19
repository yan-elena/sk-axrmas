

+!assembly(Part)[source(Ag)]
    <-  .print("received assembly in the skateboard: ");
        //?artName(W);
        //lookupArtifact(W, WkArt);


        //?focusing(WkArt,_,_,_,wsk,_);
        //focus(SkArt);


        //makeArtifact("sk", "Skateboard", [2], SkArt2);
        //linkArtifacts(WkArt, "out-1", SkArt);
        assembly;

        .print("assembly finished for part: ", Part);
        .send(Ag, signal, assembled(Part));
        .


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
