import os
import pandas as pd
from textblob import TextBlob


path = r"U:\Quick files\Junk\option wording 202412181700.xlsx"


if __name__ == "__main__":


    if not os.path.exists(path):
        quit()


    df = pd.read_excel(path)

    words = df["Word"].dropna().unique()
    descriptions = df["Desc"].dropna().unique()

    n: int = 15

    print(f"{words[:n]=}")

    # # each word is too specific
    # for i, row in df.head(n).iterrows():

    #     word = row["Word"]
    #     if not pd.isna(word):
    #         tb = TextBlob(str(word))
    #     else:
    #         tb = ""
    #         word = ""

    for i, desc in enumerate(descriptions[:n]):

        if not pd.isna(desc):
            tb = TextBlob(str(desc))
        else:
            tb = ""
            desc = ""

        print(f"'{desc}' => '{tb.correct()}'")
