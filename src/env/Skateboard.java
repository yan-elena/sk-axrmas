import cartago.Artifact;
import cartago.LINK;
import cartago.OPERATION;

public class Skateboard extends Artifact {

    private int skId;

    void init(int skId) {
        defineObsProperty("id", skId);
        this.skId = skId;
        log("SK CREATED!! " + skId);
    }

    @LINK
    @OPERATION
    void assemblyTrunk() {
        defineObsProperty("assembled", "trunk");
        log("skateboard " + skId + " has trunk installed");
    }

    @LINK
    @OPERATION
    void assemblyWheels() {
        defineObsProperty("assembled", "wheels");
        log("skateboard " + skId + " has wheel installed");
    }

    @LINK
    @OPERATION
    void assemblyOptionals() {
        defineObsProperty("assembled", "optionals");
        log("skateboard " + skId + " has optionals installed");
    }
}
