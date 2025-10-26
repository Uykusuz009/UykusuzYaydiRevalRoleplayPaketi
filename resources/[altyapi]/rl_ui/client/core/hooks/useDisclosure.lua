local disclosures = {}

function useDisclosure(key, initialValue)
    if not disclosures[key] then
        disclosures[key] = {
            isOpen = initialValue or false
        }
    end

    return {
        visible = disclosures[key].isOpen,
        open = function()
            disclosures[key].isOpen = true
        end,
        close = function()
            disclosures[key].isOpen = false
        end,
        toggle = function()
            disclosures[key].isOpen = not disclosures[key].isOpen
        end,
        params = disclosures[key].params,
        setParams = function(params)
            disclosures[key].params = params
        end,
        value = disclosures[key]
    }
end
