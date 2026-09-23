import cartago.Artifact;
import cartago.OPERATION;
import jason.asSyntax.parser.ParseException;

import java.util.*;

import static jason.asSyntax.ASSyntax.parseLiteral;
import static jason.asSyntax.ASSyntax.parseNumber;

public class OrderAssignmentsArtifact extends Artifact {

    private static final String AVAILABLE = "available";
    private static final String BUSY = "busy";
    private Map<Order, OrderStatus> orderAssignments = new HashMap<>();

    private Map<String, String> agentsAvailability = new HashMap<>();

    private List<Order> ordersQueue = new ArrayList<>();

    void init() {
        defineObsProperty("orderQueue", 0);
    }

    @OPERATION
    public void addAgent(String name) {
        this.agentsAvailability.put(name, AVAILABLE);
    }

    @OPERATION
    public void addOrder(int id, boolean preference, String deadline) {
        final Order order = new Order(id, preference, deadline);
        this.assignAgent(order);
        log("order " + order + " added");
    }

    @OPERATION
    public void checkQueueAndAssign() {
        ordersQueue.forEach(this::assignAgent);
    }

    private void assignAgent(Order order) {
        Optional<String> availableAg = this.agentsAvailability.entrySet().stream()
                                                                         .filter(e -> e.getValue().equals(AVAILABLE))
                                                                         .map(Map.Entry::getKey).findAny();
        if (availableAg.isPresent()) {
            final String agent = availableAg.get();
            this.orderAssignments.put(order, new OrderStatus(agent));
            this.agentsAvailability.put(agent, BUSY);
            try {
                defineObsProperty("order", parseNumber(String.valueOf(order.getId())), parseLiteral(agent), parseLiteral(String.valueOf(order.hasOptionals())), parseLiteral(order.getDeadline()));
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
            log("order " + order + " assigned to " + agent);
        } else {
            if (!ordersQueue.contains(order)) {
                this.ordersQueue.add(order);
                log("order " + order + " added to the queue...");
                updateObsProperty("orderQueue", ordersQueue.size());
            }
        }
    }

    @OPERATION
    public void completeBaseSkateboard(int orderId) {
        Optional<Map.Entry<Order, OrderStatus>> status = this.orderAssignments.entrySet().stream().filter(e -> e.getKey().getId() == orderId).findFirst();
        if (status.isPresent()) {
            final Order order = status.get().getKey();
            final OrderStatus orderStatus = status.get().getValue();

            orderStatus.setBaseCompleted();
            orderAssignments.put(order, orderStatus);
            this.checkCompletion(order, orderStatus);
        }
    }

    @OPERATION
    public void completeOptionalsSkateboard(int orderId) {
        Optional<Map.Entry<Order, OrderStatus>> status = this.orderAssignments.entrySet().stream().filter(e -> e.getKey().getId() == orderId).findFirst();
        if (status.isPresent()) {
            final Order order = status.get().getKey();
            final OrderStatus orderStatus = status.get().getValue();

            orderStatus.setOptionalsCompleted();
            orderAssignments.put(order, orderStatus);
            this.checkCompletion(order, orderStatus);
        }
    }

    private void checkCompletion(Order order, OrderStatus orderStatus) {
        if (!order.hasOptionals() && orderStatus.isBaseCompleted()) {
            this.agentsAvailability.put(orderStatus.getHandlingAgent(), AVAILABLE);
            log("BASE order " + order.getId() + " completed " + orderStatus.getHandlingAgent() + " free");
        } else if (order.hasOptionals() && orderStatus.isBaseCompleted() && orderStatus.isOptionalsCompleted()) {
            this.agentsAvailability.put(orderStatus.getHandlingAgent(), AVAILABLE);
            log("OPTIONAL order " + order.getId() + " completed " + orderStatus.getHandlingAgent() + " free");
        }
    }

    @OPERATION
    public void freeAgents() {
        this.agentsAvailability.keySet().forEach(a -> this.agentsAvailability.put(a, AVAILABLE));
    }
}