import os
import re

def find_trigger_server_events(directory):
    trigger_events = set()
    total_files = 0
    files_with_triggers = 0

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua'):
                total_files += 1
                file_path = os.path.join(root, file)

                try:
                    encodings = ['utf-8', 'latin1', 'cp1252', 'iso-8859-1']
                    content = None

                    for encoding in encodings:
                        try:
                            with open(file_path, 'r', encoding=encoding) as f:
                                content = f.read()
                                break
                        except UnicodeDecodeError:
                            continue

                    if content is None:
                        print(f"Uyarı: {file_path} dosyası okunamadı!")
                        continue

                    # triggerServerEvent("eventName", ...)
                    pattern = r'triggerServerEvent\s*\(\s*["\']([^"\']+)["\']'
                    matches = re.findall(pattern, content)

                    if matches:
                        files_with_triggers += 1
                        relative_path = os.path.relpath(file_path, directory)
                        print(f"{relative_path} dosyasında {len(matches)} trigger bulundu:")
                        for match in matches:
                            print(f"  - {match}")
                        trigger_events.update(matches)

                except Exception as e:
                    print(f"Hata: {file_path} dosyası işlenirken hata oluştu: {str(e)}")

    try:
        with open('trigger_server_events.txt', 'w', encoding='utf-8') as f:
            for event in sorted(trigger_events):
                f.write(f'"{event}",\n')

        print(f"\nÖzet:")
        print(f"Taranan toplam .lua dosyası: {total_files}")
        print(f"Trigger bulunan dosya sayısı: {files_with_triggers}")
        print(f"Toplam unique triggerServerEvent sayısı: {len(trigger_events)}")
        print("Tüm event'ler trigger_server_events.txt dosyasına yazıldı.")
    except Exception as e:
        print(f"Hata: trigger_server_events.txt yazılırken hata oluştu: {str(e)}")

current_directory = os.path.dirname(os.path.abspath(__file__))
parent_directory = os.path.dirname(current_directory)

print(f"Tarama başladı: {parent_directory}")
print("-------------------")
find_trigger_server_events(parent_directory)
