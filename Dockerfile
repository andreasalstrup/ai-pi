FROM alpine:3.20

RUN apk add git g++ build-base

RUN git clone https://github.com/ggerganov/llama.cpp
WORKDIR /llama.cpp
RUN make

COPY /models /llama.cpp/models
COPY /prompts /llama.cpp/prompts

CMD ./server -m models/CapybaraHermes/capybarahermes-2.5-mistral-7b.Q2_K.gguf \ 
    -c 512 \ 
    -b 512 \
    -n 512 \
    --keep 16 \
    --repeat_penalty 1.0 \
    --color \
    -i -r "User:" -f prompts/chat-with-dolphin-uncensored.txt \
    --host 0.0.0.0 \
    --port 8080

# c: context size
# b: batch size
# n: tokens to generate
# keep: preserve context
# i: interactive mode
# r: specifies reset token