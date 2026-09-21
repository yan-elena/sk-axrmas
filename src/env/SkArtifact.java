import cartago.Artifact;
import cartago.OPERATION;
import jason.asSyntax.Atom;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;
import jason.asSyntax.parser.ParseException;

import static jason.asSyntax.ASSyntax.parseLiteral;

public class SkArtifact extends Artifact {

    private static final String SK = "sk";

    void init() {
        log("Artifact initialized");
    }

    @OPERATION
    public void addSignal(String event) {
        try {
            signal(SK, parseLiteral(event));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @OPERATION
    public void addSkFact(String fact) {
        log("ADD FACT::: " + fact);
        try {
            defineObsProperty(SK, parseLiteral(fact));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @OPERATION
    public void removeSkFact(String fact) {
        try {
            if (hasObsPropertyByTemplate(SK, parseLiteral(fact))) {
                removeObsPropertyByTemplate(SK, parseLiteral(fact));
            }
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @OPERATION
    public void updateSkFact(String fact) {
        try {
            updateObsProperty(SK, parseLiteral(fact));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }
}
