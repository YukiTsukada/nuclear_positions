# Detect center of nuclear

1. Make two folders for output.
2. Open your stack file and run detect\_center\_nuclear.ijm
   The script will generate masks and individual binarized nuclear stacks (volumes) in to the designated folders.
2. Run mul\_vol\_center.ijm for the volume folder. Then it generates the file containing the center of masses (coordinates.csv).
3. Run timeline\_vols.ijm for the maks folder. It will generate timeline.csv that contains frame, minimum label, maximum label for each columns. 