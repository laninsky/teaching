# If you haven't already installed the tidyverse package, please do this now because it takes a while!
install.packages("tidyverse")

# Load the package
library(tidyverse)
# Ctrl+Enter

# We are going to grab our data (combined.csv) from:
# https://github.com/OtagoCarpentries/minibaz2020/blob/master/setup.md#data

# Specifically, our data (combined.csv) is at the following link:
# https://ndownloader.figshare.com/files/2292169

# We are now going to read in the data as an object called surveys
# using a function called read_csv()
# On a mac/linux:
surveys <- read_csv("/the/path/to/your/downloads/location/combined.csv")
# On a windows:
surveys <- read_csv("c:/the/path/to/your/downloads/folder/combined.csv")

surveys <- read_csv("/Users/alanaalexander/Downloads/combined.csv")

# To have a look at what is going on with our data
str(surveys)

# Have a look at your data like an old school excel
View(surveys)

# select() filter() seleCt() filteR()
# What happens when we type in our object name?
surveys

# selecting some columns
select(surveys,record_id,month,day)
surveys

# select to EXCLUDE column
select(surveys,-record_id,-month,-day)

# filter to get rows we are interested in
filter(surveys,year==1995)

# A pipe looks like this %>%
# Shift+Control+M %>% 
surveys %>% 
  select(-record_id,-species_id) %>% 
  filter(year==1995)

surveys

# To save the output of select/filter/pipes etc, need to assign to new variable/object
surveys_sml <- surveys %>% 
  select(-record_id,-species_id) %>% 
  filter(year==1995)

surveys_sml

# Using pipes, subset the surveys data to include animals collected before 1995 (hint <) and retain only the columns year, sex, and weight
surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)

# Create new columns based on existing ones we can use mutate()
# Create a new variable called weight_kg from weight
surveys %>% 
  mutate(weight_kg = weight/1000) %>% 
  select(weight, weight_kg)

# How to filter out NA values
surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight/1000) %>% 
  select(weight, weight_kg)

# To look at mean weight by sex using group_by() and summarise/summarize
surveys %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight,na.rm=TRUE))

surveys %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight))

# You can group by multiple columns
surveys %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight, na.rm=TRUE)) %>% 
  tail()

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  tail()

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),min_weight = min(weight))

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),min_weight = min(weight)) %>% 
  arrange(min_weight)

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),min_weight = min(weight)) %>% 
  arrange(desc(min_weight))

# Using count function to get numbers of specific categories in our dataset
surveys %>% 
  count(sex)

surveys %>% 
  count(sex, sort=TRUE)

surveys %>% 
  count(sex, species)

surveys %>% 
  count(sex, species) %>% 
  arrange(species, desc(n))

# Spread to go from tall/long format to wide, gather to go in the opposite direction
surveys_gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>% 
  summarize(mean_weight = mean(weight))

surveys_gw

# using spread
surveys_spread <- surveys_gw %>% 
  spread(key = genus, value = mean_weight)

surveys_spread

# using gather
surveys_gather <- surveys_spread %>% 
  gather(key="genus", value = "mean_weight", -plot_id)

surveys_gather
surveys_gw

# Create a dataset that we will use for the plotting lesson
surveys_complete <- surveys %>% 
  filter(!is.na(weight),
         !is.na(hindfoot_length),
         !is.na(sex))

species_counts <- surveys_complete %>% 
  count(species_id) %>% 
  filter(n >= 50)

species_counts

surveys_complete %>% select(species_id)
surveys_complete$species_id

species_counts %>% select(species_id)
species_counts$species_id

surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_counts$species_id)

surveys_complete

# Save our file out from R!
write_csv(surveys_complete, path = "data/surveys_complete.csv")

# Full notes online
https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Thanks for coming guys!


