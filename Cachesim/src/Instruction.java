/**
 * Created by BrianLin on 4/10/16.
 */
public class Instruction {

    public String type;
    public int address;
    public int numBytes;
    public String writeValue;

    private String type;
    private

    public Instruction(String type_, int address_, int numBytes_) {
        type = type_;
        address = address_;
        numBytes = numBytes_;
        writeValue = "";
    }

    public Instruction(String type_, int address_, int numBytes_, String writeValue_) {
        type = type_;
        address = address_;
        numBytes = numBytes_;
        writeValue = writeValue_;
    }


}
