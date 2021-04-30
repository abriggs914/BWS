package sample;

import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;

import java.util.Arrays;

public class Controller {

    public Label label_cost;
    public TextField textfield_cost;
    public Label label_margin;
    public TextField textfield_margin;
    public Label label_increase;
    public TextField textfield_increase;
    public Label label_exchange;
    public TextField textfield_exchange;
    public TextArea textarea_results;
    public Button button_use_calculated_cost;
    public Button button_submit;
    public Button button_clear;

    private String lastCalculated;
    private final String INVALID = "Invalid";

    private String[] collectFields() {
        String[] collection = new String[4];
        collection[0] = textfield_cost.getText();
        collection[1] = textfield_margin.getText();
        collection[2] = textfield_increase.getText();
        collection[3] = textfield_exchange.getText();
        return collection;
    }

    private double[] validate(String[] collection) {
        double[] values = new double[4];
//        System.out.println(Arrays.toString(collection));
        for(int i = 0; i < collection.length; i++) {
            String value = collection[i];
            try {
                if (value != null && value.equals("")){
                    throw new ArithmeticException();
                }
                double x = Double.parseDouble(value);
                values[i] = x;
            }
            catch (ArithmeticException e) {
                return null;
            }
        }
        return values;
    }

    private String money(double v) {
        return "$ " + String.format("%.2f", v);
    }

    private String generateOutput(double[] values) {
        double c = values[0];
        double m = values[1];
        double i = values[2];
        double e = values[3];
        c *= (1 + (i / 100));
        m = (100 - m) / 100;

        lastCalculated = Double.toString(c);

        double v = (c >= 0) ? (c / m) : (c * m);
        String cdn = money(v);
        String us = money(v / e);
        String space = "              ";
        int l = space.length();
        String left = space.substring(l / 2);
        String right = space.substring(l / 2);
        if (l % 2 == 1) {
            right += " ";
        }
        return left + "COST: " + money(c) + right + "\n" + left + "CDN:  " + cdn + right + "\n" + left + "US:   " + us + right;
    }

    public void use_calculated_cost_clicked() {
//        System.out.println("use_calculated_cost_clicked: ");
        if (lastCalculated != null && !lastCalculated.equals("")) {
            textfield_cost.setText(lastCalculated);
        }
    }

    public void clicked_submit() {
//        System.out.println("clicked_submit");
        String[] collection = collectFields();
        double[] values = validate(collection);
        if (values != null) {
            textarea_results.setText(generateOutput(values));
        }
        else {
            textarea_results.setText(INVALID);
        }
    }

    public void clicked_clear() {
//        System.out.println("clicked_clear");
        textfield_cost.setText("");
        textfield_margin.setText("");
        textfield_increase.setText("");
        textfield_exchange.setText("");
        textarea_results.setText("");
    }
}
