astroDir='astro';
targetDir="$astroDir/src/content/docs/en";
perl -0777 -i -pe 's/^export const SIDEBAR: Sidebar = {.+;\n$//gms' "$astroDir/src/consts.ts"
rm -r "$targetDir";
{
    mkdir -p "$targetDir";
    cp 'README.md' "$targetDir";
    echo "export const SIDEBAR: Sidebar = {";
    echo "  en :{";
    for chapter in Chapter*; do
        chapterSpaceRemoved=${chapter// /};
        mkdir -p "$targetDir/$chapter";
        echo "  '$chapter':  [";
        for file in "$chapter"/*; do
            filenameWithoutExtension=${file#Chapter*/};
            filenameWithoutExtension=${filenameWithoutExtension%.md}
            copyDestination=${file%.md} # remove trailing .md
            copyDestination=${copyDestination//./-} # replace . with -, 
            copyDestination=${copyDestination//\~/_} # replace ~ with _
            # copyDestination == 'Chapter 1/1-1'
            accessUrl=${copyDestination// /-} # replace space with -
            accessUrl=${accessUrl//C/c} # lowercase C to c
            cp "$file" "$targetDir/$copyDestination.md";
            echo "      { text: '$filenameWithoutExtension', link: 'en/$accessUrl' },";
        done
        echo "  ],";
    done
    echo "  }";
    echo "};";
} >> "$astroDir/src/consts.ts";

