public class Slot {
    int holding=4;

    Slot(){}

    public void add(int extra){
        this.holding += extra;
    }

    public int getNum() {
        return this.holding;
    }

    public void emptySlot() {
        this.holding = 0;
    }
}
