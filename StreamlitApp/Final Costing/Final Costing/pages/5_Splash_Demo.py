import datetime
import streamlit as st
from colour_utility import *
from typing import Any, Literal, List, Optional
from streamlit_autorefresh import st_autorefresh


colour_fg_bws: Colour = Colour("#891523")
colour_fg_stg: Colour = Colour("#152389")
key_html_style: str = "key_shimmer_style_written"


def aligned_text(
        txt: str,
        tag_style: Literal["h1", "h2", "h3", "h4", "h5", "h6", "p", "span"] = "h1",
        h_align: Literal["left", "center", "right"] = "center",
        colour: str = "#FFFFFF",
        line_height: int | float = 1,
        font_size: int = 12
) -> str:
    """
    Return formatted HTML, and in-line CSS to h_align a given text in a container.
    Use with streamlit's markdown function and with 'unsafe_allow_html' set to True.
    See coloured_text() for streamlined-colour-only functionality.
    """
    if isinstance(line_height, float):
        line_height = f"{line_height}%"
    return f"<{tag_style} style='line-height: {line_height}; text-align: {h_align}; color: {colour}; font-size: {font_size}px'>{txt}</{tag_style}>"


# Define the HTML and CSS for the animated text

def shimmer_text(
    text: str,
    text_colour: str | Colour | list[Colour] = Colour(BLACK),
    font_size: int = 18,
    h_align: Literal["left", "center", "right"] = "center",
    w_proportion_off: float = 1
    ):
        
    text_colours = [text_colour] if not isinstance(text_colour, (list, tuple)) else text_colour
    html_style = f"""
    <style>
    @keyframes shimmer {{
        0% {{ transform: rotateY(0deg); }}
        25% {{ transform: rotateY(90deg); }}
        50% {{ transform: rotateY(180deg); }}
        75% {{ transform: rotateY(270deg); }}
        100% {{ transform: rotateY(360deg); }}
    }}
    .shimmer span {{
        display: inline-block;
        animation: shimmer 8s ease-in-out infinite;
        animation-delay: calc(var(--i) * 3.5s);
    }}
    </style>
    """
    # if not st.session_state.get(key_html_style, False):
    st.markdown(html_style, unsafe_allow_html=True)
    # st.session_state[key_html_style] = True
        
    html = """
    <h1 class="shimmer" style="text-align: center;">
    """
    for i, char in enumerate(text):
        c_idx = i % len(text_colours)
        p_l = f"{(99 * w_proportion_off) / len(text)}%"
        # st.write(f"{i=}, {c_idx=}")
        html += f"""<span style="--i:{(i * 10)}; color: {text_colours[c_idx].hex_code}; text-align: {h_align}; font-size: {font_size}px; width: {p_l}">{char}</span>"""
    
    html += """
    </h1>
    """
    # st.write(html)
    return html
    

# Render the shimmer text in Streamlit
# st.write(datetime.datetime.now())
st.markdown("<br>", unsafe_allow_html=True)
# st.markdown("<h1>Welcome To</h1>", unsafe_allow_html=True)
st.markdown(aligned_text("Welcome to", tag_style="h1", font_size=22, colour="#CCCCCC"), unsafe_allow_html=True)
st.markdown("<br>", unsafe_allow_html=True)
st.markdown(shimmer_text("BWS", text_colour=colour_fg_bws, font_size=124, w_proportion_off=3/8), unsafe_allow_html=True)
st.markdown("<br>", unsafe_allow_html=True)
# st.markdown("<h4>&</h4>", unsafe_allow_html=True)
st.markdown(aligned_text("&", tag_style="h4", font_size=16, colour="#CCCCCC"), unsafe_allow_html=True)
st.markdown("<br>", unsafe_allow_html=True)
st.markdown(shimmer_text("Stargate", text_colour=colour_fg_stg, font_size=86, w_proportion_off=1/2), unsafe_allow_html=True)


# count = st_autorefresh(interval=1000*15, limit=None, key="SplashDemo")
# st.session_state[key_html_style] = False
