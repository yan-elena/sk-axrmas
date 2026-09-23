!startRm .

+!startRm : formationStatus(ok)[artifact_name(rmgroup)]
   <-
        .wait(500);
        ?play(Con,rmController,rmgroup);

        !checkPlan(adapt,detect, Con);
        !checkPlan(adapt,design, Con);
        !checkPlan(adapt,execute, Con);
      .

+!checkPlan(Cap, Sub, Con)
    <- .plan_label(P, Sub[Cap]);
       .send(Con, tell, managed(Cap, [Sub]));
       .my_name(Me);
       .print("Agent ", Me, " manages the ", Cap[Sub], " capability");
       .

/*
-!checkPlan(Cap, Sub, Con)
    <-  .concat(Cap, "_", Sub, L);
        .my_name(Me);
        .print("Agent ", Me, " DOES NOT manage the ", L, " capability");
        .
*/

+!startRm
   <-   .wait(1000);
        !startRm.