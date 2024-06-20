FROM alpine:3.20 as Build
RUN apk add git wget g++ build-base
RUN git clone https://github.com/ggerganov/llama.cpp
WORKDIR /llama.cpp
RUN make llama-server

FROM alpine:3.20 as Production
RUN apk add build-base
WORKDIR /llama.cpp/models
RUN wget https://huggingface.co/TheBloke/CapybaraHermes-2.5-Mistral-7B-GGUF/resolve/main/capybarahermes-2.5-mistral-7b.Q2_K.gguf
RUN chmod +x capybarahermes-2.5-mistral-7b.Q2_K.gguf
WORKDIR /llama.cpp
COPY /prompts ./prompts
COPY --from=Build /llama.cpp/llama-server ./llama-server

CMD ./llama-server -m models/capybarahermes-2.5-mistral-7b.Q2_K.gguf \ 
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