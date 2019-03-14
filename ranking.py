import csv

READ_PATH = 'yt_wonderland/data/world-happiness-report/2017.csv'
WRITE_PATH = 'new_data.csv'

DIMENSIONS_TO_RANK = [
    {
        "name": "Economy_GDP_Per_Capita",
        "higher_is_better": True
    },
    {
        "name": "Generosity",
        "higher_is_better": True
    },
    {
        "name": "Family",
        "higher_is_better": True
    },
    {
        "name": "Health_Life_Expectancy",
        "higher_is_better": True
    },
    {
        "name": "Freedom",
        "higher_is_better": True
    },
    {
        "name": "Trust_Government_Corruption",
        "higher_is_better": True
    },
]

with open(READ_PATH, 'r') as data_src:
    csv_reader = csv.reader(data_src)

    lines = []
    countries = []


    # read csv
    for line in csv_reader:
        lines.append(line)

    data_src.close()

    legend = lines[0]
    new_legend = list(legend)
    lines = lines[1::]
    
    # process into dicts
    for country_ln in lines:
        country = {}
        for i in xrange(len(legend)):
            if legend[i] == 'Country':
                country[legend[i]] = country_ln[i]
            elif legend[i] == 'Happiness_Rank':
                country[legend[i]] = int(country_ln[i])
            else:
                country[legend[i]] = float(country_ln[i])
        countries.append(country)


    def sort_and_add_rank(dimension, higher_is_better):
        if higher_is_better:
            countries.sort(lambda x,y: cmp(x[dimension], y[dimension]), reverse=True)
        else:
            countries.sort(lambda x,y: cmp(x[dimension], y[dimension]), reverse=False)

        for i in xrange(len(countries)):
            countries[i][dimension+"_Rank"] = i+1
            print countries[i]

    # adding ranks
    for d in DIMENSIONS_TO_RANK:
        new_legend.append(d['name']+"_Rank")
        sort_and_add_rank(d['name'], d['higher_is_better'])

    # write to output
    with open(WRITE_PATH, 'w') as new_file:
        csv_writer = csv.writer(new_file)
        csv_writer.writerow(new_legend)

        for country in countries:
            csv_row = []
            for dimension in new_legend:
                csv_row.append(country[dimension])
            csv_writer.writerow(csv_row)

    new_file.close()
