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
+!simOrder
    <-    if (orderStatus(X, _)) {
            ID = X+1;
          } else {
            ID = 1;
          }
          +orderStatus(ID, received);
          !sendOrder(ID);
          .random(R);
          .wait(R * 8000);
          !simOrder;
          .

+startOrder(ID)
    <-  -+orderStatus(ID, started);
        .

+completeOrder(ID)
    <-  -+orderStatus(ID, completed);
        .

+orderStatus(ID, Status)
    <-  .print("order n. ", ID, " status: ", Status);
        .

+!sendOrder(ID)
    <-  
        ?play(Gov, skGovernor, skgroup);
        ?nticks(Time);
        Deadline = Time + 13000;
        .send(Gov, signal, order(ID, nticks(Deadline)));
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
