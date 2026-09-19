import cartago.Artifact;
import cartago.OPERATION;

import java.util.Random;

public class QualityWkArtifact extends Artifact {

    private final Random random = new Random();


    @OPERATION
    void checkQuality() {
        log("operation control quality started...");
        try {
            int r = random.nextInt(2000, 8000);
            Thread.sleep(r);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("operation control quality completed...");
    }

}
