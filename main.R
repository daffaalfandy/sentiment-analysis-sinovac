# connect to twitter developer account
CUSTOMER_KEY <- "njqvO4xMoofljmDQBqyPfqjXo"
CUSTOMER_SECRET <- "a8Yf3ipR7xrIPphZ45l3LQuyi9K6f1jAzP4eIkg4X9z0OrujTF"
ACCESS_TOKEN <- "2164542606-znR5kpn4nTuzWT6Vk3QINbaq4UTrJAc4J3fM4AG"
ACCESS_SECRET <- "HwJGqyQouJ11nbWKXBySj5kE3HGcIQL3BeLuIC2qzyqs5"
setup_twitter_oauth(CUSTOMER_KEY, CUSTOMER_SECRET, ACCESS_TOKEN, ACCESS_SECRET)

# gathering tweets with hashtags
tweets <- searchTwitter('#sinovac', n = 1000, lang="en")
sinovac_tweets <- twListToDF(tweets)

write.csv(sinovac_tweets, file = "raw-data.csv")

# choose text column only
sinovac_text <- sinovac_tweets$text

## cleaning dataset
# ronvert all text to lower case
cleaned_data <- tolower(sinovac_text)
# replace blank space ("RT")
cleaned_data <- gsub("rt", "", cleaned_data)
# replace twitter @ username handle
cleaned_data <- gsub("@\\w+", "", cleaned_data)
# remove punctuations
cleaned_data <- gsub("[[:punct:]]", "", cleaned_data)
# remove links in texts
cleaned_data <- gsub("http\\w+", "", cleaned_data)
# remove tabs in texts
cleaned_data <- gsub("[ |\t]{2,}", "", cleaned_data)
# remove blank spaces at the beginning
cleaned_data <- gsub("^ ", "", cleaned_data)
# remove blank spaces at the end
cleaned_data <- gsub(" $", "", cleaned_data)

write.csv(cleaned_data, file = "tidy-data.csv")

## just used for creating image
corp <- Corpus(VectorSource(cleaned_data))
cleaned_data.text.corpus <- tm_map(corp, function(x)removeWords(x, stopwords()))
word_cloud_plot <- wordcloud(cleaned_data.text.corpus, min.freq = 10, colors = brewer.pal(8, "Dark2"), random.color = TRUE, max.words = 1000)


# classify emotion
class_emo = classify_emotion(cleaned_data, algorithm="bayes", prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "unknown"
# classify polarity
class_pol = classify_polarity(cleaned_data, algorithm="bayes")
# get polarity best fit
polarity = class_pol[,4]

# create and sort dataframe with results
dataframe = data.frame(text=cleaned_data, emotion=emotion, polarity=polarity, stringsAsFactors=FALSE)
## run on shiny app
# dataframe = within(dataframe, emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))
table(dataframe$emotion)

write.csv(dataframe, file = "sentiment-data.csv")

# plot distribution of emotions
## run on shiny app
# ggplot(dataframe, aes(x=emotion)) +
# geom_bar(aes(y=..count.., fill=emotion)) + scale_fill_brewer(palette="Dark2") +
# labs(x="emotion categories", y="number of tweets") + 
# labs(title = "Sentiment Analysis of Vaksin Sinovac", plot.title = element_text(size=12))

# plot distribution of polarity 
## run on shiny app
# ggplot(dataframe, aes(x=polarity)) +
# geom_bar(aes(y=..count.., fill=polarity)) + scale_fill_brewer(palette="RdGy") +
# labs(x="Polarity categories", y="Number of tweets") +
# labs(title = "Polarity Analysis of Vaksin Sinovac", plot.title = element_text(size=12))

table(dataframe$polarity)
