import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;
import jason.asSyntax.Atom;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;
import jason.asSyntax.parser.ParseException;

import static jason.asSyntax.ASSyntax.parseLiteral;

public class RmArtifact extends Artifact {

    private static final Term RM_ATOM = new Atom("rm");;

    void init() {
        log("Artifact initialized");
    }

    @OPERATION
    public void addRmFact(String fact) {
        try {
            Literal l = parseLiteral(fact);
//            l.addSource(RM_ATOM);
            if (l.hasTerm()) {
                defineObsProperty(l.getFunctor(), l.getTerms());
            } else  {
                defineObsProperty(l.getFunctor());
            }
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @OPERATION
    public void removeRmFact(String fact) {
        try {
            Literal l = parseLiteral(fact);
            if (l.hasTerm()) {
                removeObsPropertyByTemplate(l.getFunctor(), l.getTerms());
            } else {
                removeObsProperty(l.getFunctor());
            }
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }
}
