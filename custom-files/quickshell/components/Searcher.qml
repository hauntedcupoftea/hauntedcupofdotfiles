import Quickshell

import "js/fzf.es.js" as Fzf
import QtQuick

Singleton {
    required property list<QtObject> list
    property string key: "name"
    property var extraOpts: ({})
    readonly property var fzf: new Fzf.Finder(list, Object.assign({
        selector
    }, extraOpts))

    function transformSearch(search: string): string {
        return search;
    }

    function selector(item: var): string {
        return item[key];
    }

    function query(search: string): list<var> {
        search = transformSearch(search);
        if (!search)
            return [...list];

        return fzf.find(search).sort((a, b) => {
            if (a.score === b.score)
                return selector(a.item).trim().length - selector(b.item).trim().length;
            return b.score - a.score;
        }).map(r => r.item);
    }
}
