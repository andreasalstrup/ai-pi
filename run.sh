#!/bin/bash

while true; do
    ./llama-server -m models/capybarahermes-2.5-mistral-7b.Q2_K.gguf \
        -c 512 \
        -b 512 \
        -n 512 \
        --keep 16 \
        --repeat_penalty 1.0 \
        --color \
        -i -r "User:" -f prompts/chat-with-dolphin-uncensored.txt \
        --host 0.0.0.0 \
        --port 8080

    if [ $? -ne 0 ]; then
        echo "Restarting..."
        sleep 1
    else
        echo "Exiting..."
        break
    fi
done

# c: context size
# b: batch size
# n: tokens to generate
# keep: preserve context
# i: interactive mode
# r: specifies reset token