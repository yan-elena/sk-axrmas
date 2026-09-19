import cartago.*;

import java.util.Random;

//@ARTIFACT_INFO(
//        outports = {
//                @OUTPORT(name = "out-1")
//        }
//)
public class TrunkWkArtifact extends Artifact {

    private final Random random = new Random();

    @OPERATION
    void assembly() {
        log("operation install trunk started...");
        try {
            int r = random.nextInt(1000, 4000);
            Thread.sleep(r);
            //execLinkedOp("out-1", "assemblyTrunk");
        } catch (InterruptedException  e) {
            throw new RuntimeException(e);
        }
        log("operation install trunk completed...");
    }

}
