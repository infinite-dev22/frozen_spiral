module org.infinite.ui.sampling.spoty_ui_sampling {
    requires javafx.controls;
    requires javafx.fxml;

    requires org.kordamp.ikonli.javafx;

    opens org.infinite.ui.sampling.spoty_ui_sampling to javafx.fxml;
    exports org.infinite.ui.sampling.spoty_ui_sampling;
}