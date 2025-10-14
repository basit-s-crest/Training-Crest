import streamlit as st
from openai import OpenAI
from streamlit_js_eval import streamlit_js_eval
import os

# --------------------------
# Page setup
# --------------------------
st.set_page_config(page_title="StreamlitChatMessageHistory", page_icon="💬")
st.title("Chatbot Interview")

# --------------------------
# Initialize session state
# --------------------------
if "setup_complete" not in st.session_state:
    st.session_state.setup_complete = False
if "user_message_count" not in st.session_state:
    st.session_state.user_message_count = 0
if "feedback_shown" not in st.session_state:
    st.session_state.feedback_shown = False
if "chat_complete" not in st.session_state:
    st.session_state.chat_complete = False
if "messages" not in st.session_state:
    st.session_state.messages = []

# --------------------------
# Helper functions
# --------------------------
def complete_setup():
    st.session_state.setup_complete = True

def show_feedback():
    st.session_state.feedback_shown = True

# --------------------------
# Setup stage
# --------------------------
if not st.session_state.setup_complete:
    st.subheader('Personal Information')

    st.session_state["name"] = st.text_input(
        label="Name",
        value=st.session_state.get("name", ""),
        placeholder="Enter your name",
        max_chars=40
    )
    st.session_state["experience"] = st.text_area(
        label="Experience",
        value=st.session_state.get("experience", ""),
        placeholder="Describe your experience",
        max_chars=200
    )
    st.session_state["skills"] = st.text_area(
        label="Skills",
        value=st.session_state.get("skills", ""),
        placeholder="List your skills",
        max_chars=200
    )

    st.subheader('Company and Position')

    st.session_state["level"] = st.radio(
        "Choose level",
        options=["Junior", "Mid-level", "Senior"],
        index=["Junior", "Mid-level", "Senior"].index(st.session_state.get("level", "Junior"))
    )

    st.session_state["position"] = st.selectbox(
        "Choose a position",
        ("Data Scientist", "Data Engineer", "ML Engineer", "BI Analyst", "Financial Analyst"),
        index=("Data Scientist", "Data Engineer", "ML Engineer", "BI Analyst", "Financial Analyst").index(
            st.session_state.get("position", "Data Scientist")
        )
    )

    st.session_state["company"] = st.selectbox(
        "Select a Company",
        ("Amazon", "Meta", "Udemy", "365 Company", "Nestle", "LinkedIn", "Spotify"),
        index=("Amazon", "Meta", "Udemy", "365 Company", "Nestle", "LinkedIn", "Spotify").index(
            st.session_state.get("company", "Amazon")
        )
    )

    if st.button("Start Interview", on_click=complete_setup):
        st.write("Setup complete. Starting interview...")

# --------------------------
# Interview phase
# --------------------------
if st.session_state.setup_complete and not st.session_state.feedback_shown and not st.session_state.chat_complete:

    st.info("Start by introducing yourself 👋")

    # Initialize OpenRouter client
    client = OpenAI(
        base_url="https://openrouter.ai/api/v1",
        api_key= "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"  # Store your key in Streamlit secrets
    )

    # Set default OpenRouter free model
    if "openai_model" not in st.session_state:
        st.session_state["openai_model"] = "deepseek/deepseek-chat-v3.1:free"

    # Initialize system message
    if not st.session_state.messages:
        st.session_state.messages = [{
            "role": "system",
            "content": (
                f"You are an HR executive interviewing {st.session_state['name']} "
                f"with experience {st.session_state['experience']} and skills {st.session_state['skills']}. "
                f"Interview for the position {st.session_state['level']} {st.session_state['position']} "
                f"at {st.session_state['company']}."
            )
        }]

    # Display previous messages
    for msg in st.session_state.messages:
        if msg["role"] != "system":
            with st.chat_message(msg["role"]):
                st.markdown(msg["content"])

    # Chat input with max messages limit
    if st.session_state.user_message_count < 5:
        if prompt := st.chat_input("Your response", max_chars=1000):
            st.session_state.messages.append({"role": "user", "content": prompt})
            with st.chat_message("user"):
                st.markdown(prompt)

            # Generate assistant response
            with st.chat_message("assistant"):
                try:
                    completion = client.chat.completions.create(
                        model=st.session_state["openai_model"],
                        messages=[{"role": m["role"], "content": m["content"]} for m in st.session_state.messages],
                    )
                    reply = completion.choices[0].message.content
                    st.markdown(reply)
                    st.session_state.messages.append({"role": "assistant", "content": reply})
                except Exception as e:
                    st.error(f"An error occurred: {e}")

            st.session_state.user_message_count += 1

    if st.session_state.user_message_count >= 5:
        st.session_state.chat_complete = True

# --------------------------
# Feedback phase
# --------------------------
if st.session_state.chat_complete and not st.session_state.feedback_shown:
    if st.button("Get Feedback", on_click=show_feedback):
        st.write("Fetching feedback...")

if st.session_state.feedback_shown:
    st.subheader("Feedback")
    conversation_history = "\n".join([f"{msg['role']}: {msg['content']}" for msg in st.session_state.messages])

    feedback_client = OpenAI(
        base_url="https://openrouter.ai/api/v1",
        api_key="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"
    )

    try:
        feedback_completion = feedback_client.chat.completions.create(
            model="deepseek/deepseek-chat-v3.1:free",
            messages=[
                {"role": "system", "content": (
                    "You are a helpful tool providing feedback on an interviewee's performance. "
                    "Before the feedback, give a score from 1 to 10. "
                    "Format: Overall Score: // Feedback: // Give only feedback, no extra conversation."
                )},
                {"role": "user", "content": f"Evaluate this interview: {conversation_history}"}
            ]
        )
        st.write(feedback_completion.choices[0].message.content)
    except Exception as e:
        st.error(f"An error occurred: {e}")

    if st.button("Restart Interview", type="primary"):
        streamlit_js_eval(js_expressions="parent.window.location.reload()")
