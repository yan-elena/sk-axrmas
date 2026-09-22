public class Order {
    private final int id;
    private final boolean optionals;
    private final String deadline;

    public Order(int id, boolean optionals, String deadline) {
        this.id = id;
        this.optionals = optionals;
        this.deadline = deadline;
    }

    public int getId() {
        return id;
    }

    public boolean hasOptionals() {
        return optionals;
    }

    public String getDeadline() {
        return deadline;
    }

    @Override
    public String toString() {
        return "Order{" + id +
                ", " + optionals + '\'' +
                ", " + deadline + '\'' +
                '}';
    }
}
