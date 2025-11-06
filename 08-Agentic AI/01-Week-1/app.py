# %%

from dotenv import load_dotenv
from openai import OpenAI
import json
import os
import requests
from pypdf import PdfReader
import gradio as gr

# %%
load_dotenv()
#openai = OpenAI(api_key = os.getenv('OPENROUTER_API_KEY') , base_url="https://openrouter.ai/api/v1")

# %%
pushover_user = os.getenv("PUSHOVER_USER")
pushover_token = os.getenv("PUSHOVER_TOKEN")
pushover_url = "https://api.pushover.net/1/messages.json"

if pushover_user:
    print(f"Pushover user found and starts with {pushover_user[0]}")
else:
    print("Pushover user not found")

if pushover_token:
    print(f"Pushover token found and starts with {pushover_token[0]}")
else:
    print("Pushover token not found")

# %%
def push(message):
    print(f"Push: {message}")
    payload = {"user": pushover_user, "token": pushover_token, "message": message}
    requests.post(pushover_url, data=payload)

# %%
push("HEY!!")

# %%
def record_user_details(email, name="Name not provided", notes="not provided"):
    push(f"Recording interest from {name} with email {email} and notes {notes}")
    return {"recorded": "ok"}

# %%
def record_unknown_question(question):
    push(f"Recording {question} asked that I couldn't answer")
    return {"recorded": "ok"}

# %%
record_user_details_json = {
    "name": "record_user_details",
    "description": "Use this tool to record that a user is interested in being in touch and provided an email address",
    "parameters": {
        "type": "object",
        "properties": {
            "email": {
                "type": "string",
                "description": "The email address of this user"
            },
            "name": {
                "type": "string",
                "description": "The user's name, if they provided it"
            }
            ,
            "notes": {
                "type": "string",
                "description": "Any additional information about the conversation that's worth recording to give context"
            }
        },
        "required": ["email"],
        "additionalProperties": False
    }
}

# %%
record_unknown_question_json = {
    "name": "record_unknown_question",
    "description": "Always use this tool to record any question that couldn't be answered as you didn't know the answer",
    "parameters": {
        "type": "object",
        "properties": {
            "question": {
                "type": "string",
                "description": "The question that couldn't be answered"
            },
        },
        "required": ["question"],
        "additionalProperties": False
    }
}

# %%
tools = [{"type": "function", "function": record_user_details_json},
        {"type": "function", "function": record_unknown_question_json}]

# %%
def handle_tool_calls(tool_calls):
    results = []
    for tool_call in tool_calls:
        tool_name = tool_call.function.name
        arguments = json.loads(tool_call.function.arguments)
        print(f"Tool called: {tool_name}", flush=True)

        # THE BIG IF STATEMENT!!!

        if tool_name == "record_user_details":
            result = record_user_details(**arguments)
        elif tool_name == "record_unknown_question":
            result = record_unknown_question(**arguments)

        results.append({"role": "tool","content": json.dumps(result),"tool_call_id": tool_call.id})
    return results

# %%
def handle_tool_calls(tool_calls):
    results = []
    for tool_call in tool_calls:
        tool_name = tool_call.function.name
        arguments = json.loads(tool_call.function.arguments)
        print(f"Tool called: {tool_name}", flush=True)
        tool = globals().get(tool_name)
        result = tool(**arguments) if tool else {}
        results.append({"role": "tool","content": json.dumps(result),"tool_call_id": tool_call.id})
    return results

# %%
reader = PdfReader("me/linkedin.pdf")
linkedin = ""
for page in reader.pages:
    text = page.extract_text()
    if text:
        linkedin += text

with open("me/summary.txt", "r", encoding="utf-8") as f:
    summary = f.read()

name = "Ed Donner"

# %%
system_prompt = f"You are acting as {name}. You are answering questions on {name}'s website, \
particularly questions related to {name}'s career, background, skills and experience. \
Your responsibility is to represent {name} for interactions on the website as faithfully as possible. \
You are given a summary of {name}'s background and LinkedIn profile which you can use to answer questions. \
Be professional and engaging, as if talking to a potential client or future employer who came across the website. \
If you don't know the answer to any question, use your record_unknown_question tool to record the question that you couldn't answer, even if it's about something trivial or unrelated to career. \
If the user is engaging in discussion, try to steer them towards getting in touch via email; ask for their email and record it using your record_user_details tool. "

system_prompt += f"\n\n## Summary:\n{summary}\n\n## LinkedIn Profile:\n{linkedin}\n\n"
system_prompt += f"With this context, please chat with the user, always staying in character as {name}."

# %%
load_dotenv()

# %%
import copy

# Keep only fields the endpoint accepts
def _sanitize_messages(messages: list[dict]) -> list[dict]:
    clean = []
    for m in messages:
        if not isinstance(m, dict):
            continue
        role = m.get("role")
        content = m.get("content", "")
        item = {"role": role, "content": content if content is not None else ""}

        # Preserve tool-calling fields, drop everything else (e.g., metadata)
        if role == "assistant" and m.get("tool_calls"):
            # Normalize tool_calls shape
            item["tool_calls"] = [
                {
                    "id": tc.get("id"),
                    "type": tc.get("type", "function"),
                    "function": {
                        "name": (tc.get("function") or {}).get("name"),
                        "arguments": (tc.get("function") or {}).get("arguments", "{}"),
                    },
                }
                for tc in m["tool_calls"]
            ]
        elif role == "tool":
            # Tools must include tool_call_id
            if m.get("tool_call_id"):
                item["tool_call_id"] = m["tool_call_id"]

        # (Optional) Remove empty content for assistant/tool if you prefer:
        if item["content"] is None:
            item["content"] = ""

        clean.append(item)
    return clean


# %%
def chat(message: str, history: list[dict]):
    """
    - Prepends system prompt
    - Preserves history
    - Supports multi-step tool calls
    - Returns final assistant text
    """
    
    client = OpenAI(
    api_key=os.getenv('GROQ_API_KEY') ,            
    base_url="https://api.groq.com/openai/v1",
    )

    messages = [{"role": "system", "content": system_prompt}] + history + [
        {"role": "user", "content": message}
    ]

    while True:
        messages = _sanitize_messages(messages)
        resp = client.chat.completions.create(
            model="llama-3.1-8b-instant",
            messages=messages,
            tools=tools,
            tool_choice="auto",
        )

        choice = resp.choices[0]
        msg = choice.message

        if choice.finish_reason == "tool_calls" and (msg.tool_calls or []):
            # Append assistant message with tool call info (OpenAI-compatible)
            messages.append({
                "role": "assistant",
                "content": msg.content or "",
                "tool_calls": [
                    {
                        "id": tc.id,
                        "type": tc.type,
                        "function": {
                            "name": tc.function.name,
                            "arguments": tc.function.arguments,
                        },
                    }
                    for tc in msg.tool_calls
                ],
            })
            # Execute tools and append tool results
            tool_results = handle_tool_calls(msg.tool_calls)
            messages.extend(tool_results)
            continue

        # Final assistant content
        final_text = msg.content or ""
        messages.append({"role": "assistant", "content": final_text})
        return final_text

# %%
gr.ChatInterface(chat, type="messages").launch()


