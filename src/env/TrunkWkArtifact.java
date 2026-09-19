import cartago.Artifact;
import cartago.OPERATION;

import java.util.Random;

public class TrunkWkArtifact extends Artifact {

    private final Random random = new Random();

    @OPERATION
    void assembly() {
        log("operation install trunk started...");
        try {
            int r = random.nextInt(1000, 4000);
            Thread.sleep(r);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("operation install trunk completed...");
    }

}
