import cartago.Artifact;
import cartago.OPERATION;

import java.util.Random;

public class WkArtifact extends Artifact {

    private final Random random = new Random();

    @OPERATION
    void installTrunk() {
        log("operation install trunk started...");
        try {
            int r = random.nextInt(1000, 10000);
            Thread.sleep(r);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("operation install trunk completed...");
    }

    @OPERATION
    void assemblyWheel() {
        log("operation assembly wheel started...");
        try {
            int r = random.nextInt(1000, 10000);
            Thread.sleep(r);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("operation assembly wheel completed...");
    }

    @OPERATION
    void torqueTrunk() {
        log("operation torque trunk started...");
        try {
            int r = random.nextInt(1000, 10000);
            Thread.sleep(r);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("operation torque trunk completed...");
    }
}
