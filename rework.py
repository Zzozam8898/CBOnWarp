import csv

#['Name', 'ID', 'Has Block', 'Mod', 'Class']

def read():
    data = list()
    with open('item_raw.csv', newline='\n') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            data.append(row)

    return data

def toLua(data):
    before = "iddict = {"
    after = """
    }
return iddict
    """
    sep = ",\n"
    form = '[{id}]="{text_id}"' + sep
    body=''
    for i in data:
        body = body + form.format(id=i['id'], text_id=i['text_id'])


    return before + body + after

def write(data):
    with open("itemsIds.lua", 'wt') as file:
        file.write(data)

def main(data):
    toReturn = list()
    for row in data:
        toReturn.append({
            "text_id":row[0],
            "id": row[1]
        })
    return toReturn

if __name__=="__main__":
    d=read()[1:]
    reworked = main(d)
    write(toLua(reworked))
