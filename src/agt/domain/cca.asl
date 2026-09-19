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
          .random(R);
          if (R > 0.5) {
            !sendOrder(ID, optionals);
          }
          else {
            !sendOrder(ID, basic);
          }

          .wait(R * 8000);
          !simOrder;
          .

// order events

+startOrder(ID)
    <-  ?orderStatus(ID, S);
        +orderStatus(ID, started);
        -orderStatus(ID, S);
        .

+completeOrder(ID)
    <-  ?orderStatus(ID, S);
        +orderStatus(ID, fulfilled);
        -orderStatus(ID, S);
        .

+delayOrder(ID)
    <-  ?orderStatus(ID, S);
        +orderStatus(ID, delayed);
        -orderStatus(ID, S);
        .

+orderStatus(ID, Status)
    <-  .print("order n. ", ID, " status: ", Status);
        .

+!sendOrder(ID, Pref)
    <-  
        ?play(Gov, skGovernor, skgroup);
        ?nticks(Time);
        Deadline = Time + 25000;
        .send(Gov, signal, order(ID, Pref, nticks(Deadline)));
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
