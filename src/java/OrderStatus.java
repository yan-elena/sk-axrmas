public class OrderStatus {
    private final String handlingAgent;

    private boolean baseCompleted;

    private boolean optionalsCompleted;

    public OrderStatus(String handlingAgent) {
        this.handlingAgent = handlingAgent;
        this.baseCompleted = false;
        this.optionalsCompleted = false;
    }

    public String getHandlingAgent() {
        return handlingAgent;
    }

    public boolean isBaseCompleted() {
        return baseCompleted;
    }

    public boolean isOptionalsCompleted() {
        return optionalsCompleted;
    }

    public void setBaseCompleted() {
        this.baseCompleted = true;
    }

    public void setOptionalsCompleted() {
        this.optionalsCompleted = true;
    }

    @Override
    public String toString() {
        return "OrderStatus{" + handlingAgent +
                ", " + baseCompleted +
                ", " + optionalsCompleted +
                '}';
    }
}
