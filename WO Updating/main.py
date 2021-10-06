from pygame_utility import *

col_names = [
    "Machine Shop",
    "Axles",
    "Beam",
    "GNK",
    "Line",
    "Step1",
    "Step2",
    "Blast",
    "Paint",
    "Finish",
    "Finish - GNK",
    "Final Assembly",
    "Tire Assembly",
]

template = """
USE BWSdb
GO

DECLARE @QS TABLE ([Quote#] INT);
INSERT INTO @QS VALUES 
	{qlst}
;

SELECT
	*
FROM
	[Order Hours]
WHERE 
	[Quote#] IN (
		SELECT
			[Quote#]
		FROM @QS
	)
;

BEGIN TRAN;

UPDATE
	[Order Hours]
SET
	{vals_lst}
WHERE 
	[Quote#] IN (
		SELECT
			[Quote#]
		FROM @QS
	)
;

SELECT
	*
FROM
	[Order Hours]
WHERE 
	[Quote#] IN (
		SELECT
			[Quote#]
		FROM @QS
	)
;

ROLLBACK;
COMMIT;
"""


def main_loop():
    app = PygameApplication("Create Custom WO Update Queries", 750, 700)
    game = app.get_game()
    display = app.display

    rect_lbl_quote_number = Rect2(10, 30, 160, 32)
    rect_tbox_quote_number = Rect2(160 + 10, 30, 160, 32)

    lbl_quote_number = Label(game, display, rect_lbl_quote_number, init_txt="Quote #", fs=24)
    tbox_quote_number = TextBox(game, display, rect_tbox_quote_number, numeric=True, fs=24)

    tbox_cols = []
    lbls_cols = []
    i = 0
    for i, label in enumerate(col_names):
        label_rect = Rect2(10, 30 + ((i + 1) * (32 + 4)), 160, 32)
        input_rect = Rect2(160 + 10, 30 + ((i + 1) * (32 + 4)), 160, 32)
        lbls_cols.append(Label(game, display, label_rect, init_txt=label, fs=24))
        tbox_cols.append(TextBox(game, display, input_rect, numeric=True, fs=24))

    def clear_all_tbox():
        tbox_quote_number.clear()
        for tbox in tbox_cols:
            tbox.clear()

    def submit():
        q_num = tbox_quote_number.get_text()
        vals = ", ".join(["[" + str(lbl.text_str) + "] = " + tbox.get_text() for lbl, tbox in zip(lbls_cols, tbox_cols) if tbox.get_text()])
        print("vals: <" + vals + ">")
        if not q_num or not vals:
            return
        parsed = template.format(
            qlst="""
    ({})
                """.format(q_num),
            vals_lst="""
    {}
                """.format(vals)
        )
        print("submit\n" + parsed)

    rect_clear_button = Rect2(10, ((i + 3) * (32 + 4)), 160, 32)
    rect_submit_button = Rect2(160 + 10, ((i + 2) * (32 + 4)), 160, 32)
    control_panel = ButtonBar(game, display,
                              Rect2(10, rect_clear_button.y, rect_clear_button.width + rect_submit_button.width,
                                    rect_clear_button.height))
    control_panel.add_button("clear", RED_4__DARKRED_, RED_2, clear_all_tbox)
    control_panel.add_button("submit", GREEN_4, GREEN_1__LIME_, submit)

    while app.is_playing:
        display.fill(BLACK)

        lbl_quote_number.draw()
        tbox_quote_number.draw()
        for lbl, tbox in zip(lbls_cols, tbox_cols):
            lbl.draw()
            tbox.draw()
        control_panel.draw()

        event_queue = app.run()
        for event in event_queue:
            tbox_quote_number.handle_event(event)
            for tbox in tbox_cols:
                tbox.handle_event(event)
        app.clock.tick(25)


if __name__ == '__main__':
    print('PyCharm')
    main_loop()
