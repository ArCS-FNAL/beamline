import ROOT

filename = '/pnfs/lariat/persistent/users/mdeltutt/BeamLineSimOutputs/pos60Amps/MergedAtStartLinesim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps_9351.root'
infile = infile = ROOT.TFile(filename)

tree = infile.Get('EventTree_Spill1091')

outfile = ROOT.TFile("out.root","recreate")
outtree = tree.CopyTree("TrackPresentDet4==1")
outtree.Write()
outfile.Close()

