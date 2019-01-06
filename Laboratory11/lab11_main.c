#include <stdio.h>
#include <string.h>

int countLetters(char word[]);

int main() {
    char sentence[100];
    printf("Please enter your statement:\n");
    scanf("%[^\n]s", sentence);

    char* word;
    printf("All the words from the above sentence with their letters count:\n");
    word = strtok(sentence, " ,.-?!");
    while (word != NULL)
    {
        printf("%s - ", word);
        int lettersCount = countLetters(word);
        printf("%d %s\n", lettersCount, lettersCount == 1 ? "letter" : "letters");
        word = strtok(NULL, " ,.-?!");
    }

    return 0;
}
