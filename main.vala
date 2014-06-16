using Gtk;

const string GETTEXT_PACKAGE = "main";
const int SENDMODE_ORIGINAL = 1;
const int SENDMODE_1K = 2;
const int SENDMODE_2K = 3;
const int SENDMODE_10MB = 4;
int send_mode = 1;
Gdk.Pixbuf[] images = null;
string[] original_images = null;

public void on_SendButton_clicked(Button source){
    var subject = _("Message with images");
    var body = _("Hello, \n\nHere are some images");
    var mailprog = "thunderbird";
    var command = @"$mailprog -compose \"subject='$subject',body='$body',attachment='";
    switch (send_mode){
        case SENDMODE_ORIGINAL:
            for (int i = 0; i < original_images.length; i++){
                var attachment = original_images[i];
                command += @"file://$attachment,";
            }
            break;
    }
    command = command.substring(0, command.length-1);
    command += "'\"";
    stdout.printf("Start: %s\n", command);
    Process.spawn_command_line_async(command);
    Gtk.main_quit();
}

public void on_CancelButton_clicked(Button source){
    Gtk.main_quit();
}

public void on_SizeRadio_group_changed(RadioButton source){
    if (source.get_active()){
        stdout.printf("%s\n", source.name);
        switch (source.name) {
            case "OriginalRadio":
                send_mode = SENDMODE_ORIGINAL;
                break;
            case "SmallRadio":
                send_mode = SENDMODE_1K;
                break;
            case "BigRadio":
                send_mode = SENDMODE_2K;
                break;
            case "MaxRadio":
                send_mode = SENDMODE_10MB;
                break;
        }
    }
}

int main (string[] args) {
    Gtk.init(ref args);

    Intl.setlocale(LocaleCategory.MESSAGES, "");
    Intl.textdomain(GETTEXT_PACKAGE);
    Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "utf-8");
    Intl.bindtextdomain(GETTEXT_PACKAGE, "./locale");

    try{
        var builder = new Builder ();
        builder.add_from_file ("main.ui");
        builder.connect_signals (null);
        var window = builder.get_object("EmailDialog") as Dialog;
        window.show_all();

        var countLabel = builder.get_object("CountLabel") as Label;
        countLabel.label = _("You selected %d images\n").printf( args.length - 1 );
        original_images = args[1:args.length];
        images = new Gdk.Pixbuf[args.length - 1];
        int64 total_size = 0;
        for (int i = 1; i < args.length; i++){
            images[i] = new Gdk.Pixbuf.from_file(args[i]);
            File file = File.new_for_path(args[i]);
            FileInfo file_info = file.query_info("standard::size", FileQueryInfoFlags.NONE);
            int64 file_size = file_info.get_size();
            total_size += file_size;
            stdout.printf("Loaded %s: %" + uint64.FORMAT_MODIFIER + "d bytes\n", args[i], file_size);
        }
        stdout.printf("Total: %s\n", format_size_for_display(total_size));

        var originalSizeLabel = builder.get_object("OriginalSizeLabel") as Label;
        originalSizeLabel.label = _("Original size: %s").printf( format_size_for_display(total_size));

        var programCombo = builder.get_object("ProgramCombo") as ComboBox;
        ListStore programList = new ListStore (1, typeof (string));
        string[] programs = {"Thunderbird"};
        for (int i = 0; i < programs.length; i++){
            TreeIter iter;
            programList.append(out iter);
            programList.set (iter, 0, programs[i]);
        }
        programCombo.set_model(programList);
        CellRendererText renderer = new CellRendererText();
        programCombo.pack_start(renderer, true);
        programCombo.add_attribute(renderer, "text", 1);
        programCombo.active = 0;

        Gtk.main ();
    } catch (Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
        return 1;
    }
    return 0;
}
