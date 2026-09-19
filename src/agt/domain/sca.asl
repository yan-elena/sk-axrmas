


+!assembledSk(Id)
    <-
        .print("start assembly skateboard id: ", Id);
        ?play(WAg, trunkWsHandler, skgroup);
        .send(WAg, achieve, assembly(trunk, Id));
        .


+assembled(trunk, Id)
    <-  .print("trunk installed on ", Id);
        ?play(WAg, wheelWsHandler, skgroup);
        .send(WAg, achieve, assembly(wheel, Id));
        .


+assembled(wheel, Id)
    <-  .print("wheel installed on ", Id);
        ?play(WAg, optionalWsHandler, skgroup);
        .send(WAg, achieve, assembly(optional, Id));
        .

+assembled(optional, Id)
 <-  .print("optional installed on ", Id);
     ?play(WAg, qualityWsHandler, skgroup);
     .send(WAg, achieve, checkQuality(Id));
     .

+checkedQuality(Id)
    <-  .print("completed assembly skateboard id: ", Id);
        ?play(Ag, skGovernor, skgroup);
        .send(Ag, tell, assembledSk(Id));
        .

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
