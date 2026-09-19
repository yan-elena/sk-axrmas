import cartago.Artifact;
import cartago.OPERATION;

import java.util.Random;

public class WheelWkArtifact extends Artifact {

    private final Random random = new Random();

    @OPERATION
    void assembly() {
        log("operation assembly wheel started...");
        try {
            int r = random.nextInt(2000, 8000);
            Thread.sleep(r);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("operation assembly wheel completed...");
    }
}
