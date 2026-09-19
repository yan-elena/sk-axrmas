import cartago.Artifact;
import cartago.ArtifactId;
import cartago.OPERATION;
import cartago.OperationException;

import java.util.Random;

public class OptionalWkArtifact extends Artifact {

    private final Random random = new Random();

    @OPERATION
    void assembly() {
        log("operation install optionals started...");
        try {
            int r = random.nextInt(1000, 4000);
            Thread.sleep(r);
            //execLinkedOp(skArt, "assemblyOptionals");
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("operation install optionals completed...");
    }

}
