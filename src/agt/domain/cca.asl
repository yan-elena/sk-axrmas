// Agent sample_agent in project main

/* Initial beliefs and rules */


/* Initial goals */

!start.

/* Plans */
+!start : formationStatus(ok)
    <-  .wait(3000);
        .print("started producing orders.");
        !init_clock;

        !simOrder;
        .

+!start
   <-   .wait(1000);
        !start.


// simulating new orders
+!simOrder : simuStep(T)
    <-    if (orderStatus(X, _)) {
            ID = X+1;
          } else {
            ID = 1;
          }
          +orderStatus(ID, received);
          .random(R);
          if (R > 0.3) {
            !sendOrder(ID, true);
          }
          else {
            !sendOrder(ID, false);
          }

          .wait((R+0.5) * T);
          !simOrder;
          .


+!sendOrder(ID, Opt)
    <-  
        ?play(Gov, skController, skgroup);
        ?nticks(Time);
        Deadline = Time + 25000;
        .send(Gov, signal, order(ID, Opt, nticks(Deadline)));
        .


//start the clock artifact
+!init_clock <-
    setFrequency(1);
    start; //start the clock
.


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
