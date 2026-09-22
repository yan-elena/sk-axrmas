handleSkateboard(0, none).

// assembly base parts

+!makeSk(Id, SkId, SkArt)
    <-  makeArtifact(SkId, "Skateboard", [Id], SkArt);
        focus(SkArt);
        .print("skateboard artifact created: ", SkArt);
        -+handleSkateboard(Id, SkArt);
        .

-!makeSk(Id, SkId, SkArt)
    <-  .print("artifact already created");
        .

+!assembledBaseSk(Id)
    <-  .concat("sk", Id, SkId);
        if (not focusing(A,SkId,_,_,_,_)) {
            !makeSk(Id, SkId, SkArt);
        }
        .print("start assembly base skateboard id: ", Id);

        // request trunk handler to assembly trunk
        ?play(WAg, trunkWsHandler, skgroup);
        .send(WAg, achieve, assembly(trunk));
        .


+assembled(trunk) : handleSkateboard(Id, SkArt)
    <-  .print("trunk installed on ", Id);
        assemblyTrunk;
        ?play(WAg, wheelWsHandler, skgroup);
        .send(WAg, achieve, assembly(wheels));
        .


+assembled(wheels) : handleSkateboard(Id, SkArt)
    <-  .print("wheel installed on ", Id);
        assemblyWheels;
        ?play(Ag, skController, skgroup);
        .send(Ag, tell, assembledBaseSk(Id)); //done
        .print("done base");
        .


// assembly optional parts


+!assembledOptionals(Id)
    <-  .concat("sk", Id, SkId);
        if (not focusing(A,SkId,_,_,_,_)) {
            !makeSk(Id, SkId, SkArt);
        }
        .print("start assembly optional parts skateboard id: ", Id);
        ?play(WAg, optionalWsHandler, skgroup);
        .send(WAg, achieve, assembly(optionals));
        .


+assembled(optionals) : handleSkateboard(Id, SkArt)
 <-  .print("optional installed on ", Id);
     assemblyOptionals;
     //?play(WAg, qualityWsHandler, skgroup);
     //.send(WAg, achieve, checkQuality(SkArt));

    ?play(Ag, skController, skgroup);
    .send(Ag, tell, assembledOptionals(Id)); //done
    .print("done optionals");
     .

+checkedQuality(SkArt)
    <-  .print("completed quality check skateboard id: ", SkArt);
        //todo
        .

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
