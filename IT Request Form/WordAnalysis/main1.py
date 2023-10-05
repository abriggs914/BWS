# Python program to generate WordCloud

# importing all necessary modules
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from PIL import Image


# How to Create Beautiful Word Clouds in Python
# https://towardsdatascience.com/how-to-create-beautiful-word-clouds-in-python-cfcf85141214



# Reads 'Youtube04-Eminem.csv' file
# df = pd.read_csv(r"Youtube04-Eminem.csv", encoding="latin-1")
df = pd.read_excel("./Word Analysis.xlsx")
df = df[["Word", "TtlRequests"]]
df.fillna("", inplace=True)
df["TtlRequests"] = df["TtlRequests"].astype(str)

comment_words = ''
stopwords = set(STOPWORDS)

# # # iterate through the csv file
# # for val in df.CONTENT:
# #
# #     # typecaste each val to string
# #     val = str(val)
# #
# #     # split the value
# #     tokens = val.split()
# #
# #     # Converts each token into lowercase
# #     for i in range(len(tokens)):
# #         tokens[i] = tokens[i].lower()
# #
# #     comment_words += " ".join(tokens) + " "
#
# ii = 0
# for tup_ in df.itertuples():
#     i, *tup = tup_
#     # if ii < 5:
#     #     print(f"{i=}, {tup=}, {type(tup)=}")
#     # ii = ii + 1
#     df.iloc[i] = [f"'{v}'".replace("''", "'") for v in tup]
#
# words_list_og = df["Word"].unique().tolist()
# words_list = []
# for i, word in enumerate(words_list_og):
#     for j in range(int(df.iloc[i]["TtlRequests"].replace("'", "")) + 1):
#         words_list.append(word)
#
# print(f"{len(words_list_og)=} {words_list_og=}")
# print(f"{len(words_list)=} {words_list=}")
#
# # print(f"{df['Word'].unique().tolist()=}")
# # print(f"{' '.join(df['Word'].unique().tolist())=}")
# comment_words = " " + " ".join(words_list) + " "
# # print(f"{comment_words=}")

# Get BWS Logo
# bws_logo = np.array(Image.open(r"C:\Access\BWS Chrome Final WO Manufacturing.jpg"))
# logo = bws_logo
stargate_logo = np.array(Image.open(r"C:\Access\Stargate Logo 50%.jpg"))
logo = stargate_logo
colours = ImageColorGenerator(logo)

with open("rawReqestText_2023-10-04.txt", "r") as f:
    comment_words = f.read()

# purge special words
purge_words_og = ["JWC"]
purge_words = set()

# complete purge words
for pw in purge_words_og:
    purge_words.add(pw)
    purge_words.add(pw.lower())
    purge_words.add(pw.upper())
    purge_words.add(pw.title())

# purge words
for pw in purge_words:
    comment_words = comment_words.replace(pw, "")

# re-align spaces
while comment_words.count("  "):
    comment_words = comment_words.replace("  ", " ")

wordcloud = WordCloud(width=800, height=800,
                      background_color='white',
                      stopwords=stopwords,
                      mask=logo,
                      color_func=colours,
                      min_font_size=10).generate(comment_words)
# wordcloud = WordCloud(width=800, height=800,
#                       background_color='#ededed',
#                       stopwords=stopwords,
#                       min_font_size=10).generate_from_frequencies(comment_words)

# plot the WordCloud image
plt.figure(figsize=(8, 8), facecolor=None)
plt.imshow(wordcloud)
plt.axis("off")
plt.title("BWS Request Data")
plt.tight_layout(pad=0)

plt.show()
