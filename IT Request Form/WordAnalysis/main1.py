# Python program to generate WordCloud

# importing all necessary modules
from wordcloud import WordCloud, STOPWORDS
import matplotlib.pyplot as plt
import pandas as pd

# Reads 'Youtube04-Eminem.csv' file
# df = pd.read_csv(r"Youtube04-Eminem.csv", encoding="latin-1")
df = pd.read_excel("./Word Analysis.xlsx")
df = df[["Word", "TtlRequests"]]
df.fillna("", inplace=True)
df["TtlRequests"] = df["TtlRequests"].astype(str)

comment_words = ''
stopwords = set(STOPWORDS)

# # iterate through the csv file
# for val in df.CONTENT:
#
#     # typecaste each val to string
#     val = str(val)
#
#     # split the value
#     tokens = val.split()
#
#     # Converts each token into lowercase
#     for i in range(len(tokens)):
#         tokens[i] = tokens[i].lower()
#
#     comment_words += " ".join(tokens) + " "

ii = 0
for tup_ in df.itertuples():
    i, *tup = tup_
    # if ii < 5:
    #     print(f"{i=}, {tup=}, {type(tup)=}")
    # ii = ii + 1
    df.iloc[i] = [f"'{v}'".replace("''", "'") for v in tup]

words_list_og = df["Word"].unique().tolist()
words_list = []
for i, word in enumerate(words_list_og):
    for j in range(int(df.iloc[i]["TtlRequests"].replace("'", "")) + 1):
        words_list.append(word)

print(f"{len(words_list_og)=} {words_list_og=}")
print(f"{len(words_list)=} {words_list=}")

# print(f"{df['Word'].unique().tolist()=}")
# print(f"{' '.join(df['Word'].unique().tolist())=}")
comment_words = " " + " ".join(words_list) + " "
# print(f"{comment_words=}")

wordcloud = WordCloud(width=800, height=800,
                      background_color='white',
                      stopwords=stopwords,
                      min_font_size=10).generate(comment_words)

# plot the WordCloud image
plt.figure(figsize=(8, 8), facecolor=None)
plt.imshow(wordcloud)
plt.axis("off")
plt.tight_layout(pad=0)

plt.show()