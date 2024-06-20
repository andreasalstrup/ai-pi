FROM alpine:3.20 as Build
RUN apk add git wget g++ build-base
RUN git clone https://github.com/ggerganov/llama.cpp
WORKDIR /llama.cpp
RUN make llama-server

FROM alpine:3.20 as Production
RUN apk add bash build-base
WORKDIR /llama.cpp/models
RUN wget https://huggingface.co/TheBloke/CapybaraHermes-2.5-Mistral-7B-GGUF/resolve/main/capybarahermes-2.5-mistral-7b.Q2_K.gguf
RUN chmod +x capybarahermes-2.5-mistral-7b.Q2_K.gguf
WORKDIR /llama.cpp
COPY /run.sh .
RUN chmod +x ./run.sh
COPY /prompts ./prompts
COPY --from=Build /llama.cpp/llama-server ./llama-server

CMD ./run.sh